// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Random {
    event paidAddress(address indexed sender, uint256 payment);
    event winnerAddress(address indexed winner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    mapping(uint256 => mapping(address => bool)) public paidAddressList;

    address public owner;
    string private key1;
    uint private key2;
    uint private winnerNumber = 0;

    uint256[] public nameArray = [1, 2, 3, 4, 5];

    uint public round = 1;
    uint public playNumber = 0;

    mapping(uint256 => uint256) public votes;
    uint256 public totalPrizeAmount; // 총 상금 금액 추가

    bool public gameStarted;

    constructor(string memory _key1, uint _key2) {
        owner = msg.sender;
        key1 = _key1;
        key2 = _key2;
        winnerNumber = 1;
        gameStarted = false;
    }

    receive() external payable {
        require(paidAddressList[round][msg.sender] == false, "Must be the first time.");
        require(gameStarted == true, "Game not started.");
        paidAddressList[round][msg.sender] = true;
        ++playNumber;

        if (playNumber == nameArray.length) {
            address[] memory winners = getWinners();
            require(winners.length > 0, "No winners found.");
            uint256 prizePerWinner = address(this).balance / winners.length; // 총 상금을 수상자 수로 나눔

            for (uint256 i = 0; i < winners.length; i++) {
                (bool success, ) = winners[i].call{value: prizePerWinner}("");
                require(success, "Failed to send ETH to a winner.");
                emit winnerAddress(winners[i]);
            }

            playNumber = 0;
            ++round;
        } else {
            emit paidAddress(msg.sender, msg.value);
        }
    }

    function gameStart() public onlyOwner() {
        require(gameStarted == false, "Game is already in progress.");
        round = 1;
        winnerNumber = 1;
        gameStarted = true;
    }

    function vote(uint256 choice) public payable {
        require(msg.value == 10**16, "Must be 0.01 ether.");
        require(choice >= 0 && choice < nameArray.length, "Invalid choice.");
        require(paidAddressList[round][msg.sender] == false, "Already voted.");
        require(gameStarted == true, "Game not started.");
        paidAddressList[round][msg.sender] = true;
        votes[choice]++;
        emit paidAddress(msg.sender, msg.value);
    }

    function getWinners() internal view returns (address[] memory) {
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < nameArray.length; i++) {
            if (votes[i] > maxVotes) {
                maxVotes = votes[i];
            }
        }

        uint256 count = 0;

        for (uint256 i = 0; i < nameArray.length; i++) {
            if (votes[i] == maxVotes) {
                count++;
            }
        }

        address[] memory winners = new address[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < nameArray.length; i++) {
            if (votes[i] == maxVotes) {
                winners[index] = address(uint160(nameArray[i]));
                index++;
            }
        }

        return winners;
    }

    function setSecretKey(string memory _key1, uint _key2) public onlyOwner() {
        key1 = _key1;
        key2 = _key2;
    }

    function getSecretKey() public view onlyOwner() returns (string memory, uint) {
        return (key1, key2);
    }

    function getWinnerNumber() public view onlyOwner() returns (uint256) {
        return winnerNumber;
    }

    function getRound() public view returns (uint256) {
        return round;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}