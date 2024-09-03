// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Twitter{
    struct Tweet{
        uint id;
        address authore;
        string content;
        uint createdAt;
    }

    struct message {
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
    }

    mapping (uint => Tweet) public tweets;
    mapping (address => uint []) public tweetsOf;
    mapping (address => message []) public  conversations;
    mapping (address => mapping (address => bool)) public operator;
    mapping (address => address []) public following;

    uint nextId;
    uint messageId;

    function _tweet(address _from,string memory _content) public {
        require(_from==msg.sender || operator[_from][msg.sender],"You don't have access");
        tweets[nextId] = Tweet(nextId,_from,_content,block.timestamp);
        tweetsOf[_from].push(nextId);
        nextId++;
    }

    function _sendMessage(address _from,address _to,string memory _content) public {
        conversations[_from].push(message(messageId,_content,_from,_to,block.timestamp));
        messageId++;
    }

    function tweet(string memory _content) public {
        _tweet(msg.sender, _content);
    }

    function tweet(address _from,string memory _content) public {
        _tweet(_from, _content);
    }

    function sendMessage(address _to,string memory _content) public {
        _sendMessage(msg.sender, _to, _content);
    }

    function sendMessage(address _from,address _to,string memory _content) public {
        _sendMessage(_from, _to, _content);
    }

    function follow(address _followed) public  {
        following[msg.sender].push(_followed);
    }

    function allow(address _opretor)public {
        operator[msg.sender][_opretor]=true;
    }

    function disAllow(address _opretor)public {
        operator[msg.sender][_opretor]=false;
    }

    function getLatestTweet(uint count) public view returns (Tweet[] memory) {
        require(count > 0 && count < nextId,"Count is not in limit");
        Tweet[] memory _tweets = new Tweet[](count);

        uint j;
        for(uint i = nextId-count;i<nextId;i++){
            Tweet storage _structure = tweets[i];
            _tweets[j++] = Tweet(_structure.id,_structure.authore,_structure.content,_structure.createdAt);
        }

        return _tweets;
    }

    function getLatestOfUser(address _user,uint count) public view returns(Tweet [] memory) {
        require(count>0 && count <nextId, "user with this address dont have post");
        Tweet[] memory _tweets = new Tweet[](count);
        uint len = tweetsOf[_user].length;
        uint[] storage idsOfUser = tweetsOf[_user];

        uint j;
        for(uint i=len-count;i<len;i++){
            Tweet storage _structure = tweets[idsOfUser[i]];
            _tweets[j++] = Tweet(_structure.id,_structure.authore,_structure.content,_structure.createdAt);
        }

        return _tweets;
    }
}