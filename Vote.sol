// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Vote{
    event paidAddress(address indexed sender, uint256 payment);  //eth를 전송한 주소와 금액에 대한 이벤트
    event winnerAddress(address indexed winner);//우승자의 주소로 가는 이벤트

    modifier onlyOwner() { //스마트 컨트랙트 owner만 접근 가능하게 하는 접근제한자
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    mapping(uint256 => mapping(address => bool)) public paidAddressList;  //설정 금액에 맞는 eth를 전송한 플레이어의 주소들을 저장하는 매핑변수
    mapping(uint256 => mapping(address => bool)) public Voted; //eth를 전송 후 투표를 끝낸 플레이어들의 주소를 저장하는 매핑변수


    address public owner; //owner의 주소 저장 변수
    string private key1; //게임의 key
    uint private key2;  //게임의 key

    address[] nameArray = new address[](20); //플레이어들의 주소를 저장 할 변수
    uint256 private requiredValue = 0;//베팅금액을 저장하는 변수
    string private valuestr = "";//에러메시지의 금액을 나타낼 변수
    uint private round = 1;  //round를 나타내는 변수
    uint private VotedNumber = 0;  //투표를 끝낸 플레이어의 수를 저장하는 변수

    mapping(uint256 => uint256) public votes;  //n번 플레이어의 듣표수를 저장하는 매핑변수
    uint256 private totalPlayer; //게임 참여 인원 수

    bool public gameStarted;  //게임의 시작여부를 나타내는 변수

    constructor(string memory _key1, uint _key2) {  //생성자(키값을 받아 시작작)
        owner = msg.sender;  //주소형owner 변수에 게임을 배포한 플레이어의 주소를 저장
        key1 = _key1;      //입력받은 key값으로 초기화
        key2 = _key2;
        gameStarted = false;  //game 배포 시 게임 시작 false 상태 유지 
        
    }

    receive() external payable {  //플레이어로 부터 eth를 전송받기 위한 함수
        require(msg.value == requiredValue, string(abi.encodePacked("Must be ", valuestr, " ether.")));      //플레이어로 부터 전송받는 금액이 올바를때만 통과하는제한자
        //require(msg.value == 10**16, "Must be 0.01 ether."); 
        require(paidAddressList[round][msg.sender] == false, "Must be the first time.");  //이미 금액을 전송했던 플레이어인지 체크하는 제한자 
        require(gameStarted == true, "Game not started.");  //게임의 시작여부를 판단하는 제한자, 아직 시작하지 않았으면 error
        paidAddressList[round][msg.sender] = true; //모든 조건을 통과했다면 금액을 전송한 플레이어를 순서에 맞게게 paidAddressList리스트에 true상태로 저장
        
    }
    function ChangeValuestr() private{  //배팅금액에 따라 출력할 에러메시지의 변수 변경
        if(requiredValue==10**16)
        {
            valuestr="0.01";
        }
        valuestr="0.02";
    }
    function randomNumber() private view returns (uint) {  //랜덤한 배팅금액을 결정하는 함수
        uint num = uint(keccak256(abi.encode(key1))) + key2 + (block.timestamp) + (block.number);
    
    // 첫 번째 경우 (10^16)
        if (num % 2 == 0) { 
            return 10**16;
        }
    
    // 두 번째 경우 (20^16)
        return 2*(10**16);
    }
    function gameStart(uint256 NumPlayer) public onlyOwner() { //게임을 시작하는 함수로, 배포자에게 플레이어 수를 입력 받아 몇명이서 플레이 할지 결정한다.
        require(gameStarted == false, "Game is already in progress.");  //이미 게임시작 버튼을 눌러 게임이 진행중이라면 error
        require(NumPlayer > 1, "At least two players are required.");  //자기자신에게 투표할 수 없기 때문에 최소 두명이상의 플레이어를 설정하도록 제한
        gameStarted = true;  //게임 시작
        requiredValue = randomNumber();
        ChangeValuestr();
        totalPlayer = NumPlayer;  //총 플레이어수를 받아 변수에 저장
    }

    function vote(uint256 choice) public payable {  //eth를 지불한 플레이어가 투표를 할 수 있도록 하는 함수
        require(choice != VotedNumber, "You cannot vote yourself");  //자기 자신에게는 투표할 수 없도록 제한
        require(choice >= 0 && choice < totalPlayer, "Invalid choice.");   //총 플레이어 수에 맞는 번호를 투표하도록 제한
        require(Voted[round][msg.sender] == false && paidAddressList[round][msg.sender] == true , "Already voted or Did not send 0.01 ether yet");  // 이미 투표했거나 아직 eth를 전송하지 않은 플레이어 제한
        require(gameStarted == true, "Game not started.");  //해당 라운드에서 배포자가 게임 시작버튼을 눌러 게임을 시작 하지 않았을 때 제한
        Voted[round][msg.sender] = true;// 모든 제한조건을 통과했다면 투표자 명단에 추가
        nameArray[VotedNumber] = msg.sender;  //투표자의 주소를 저장
        votes[choice]++; //득표한 번호의 득표수를 증가
        ++VotedNumber;// 투표를 마친 사람의 수를 증가
        if (VotedNumber == totalPlayer) {  //총 플레이어 수와 투표를 마친 사람의 수가 같아졌을 때
            address[] memory winners = getWinners();  //우승자를 가리기위한 함수를 실행하여 우승자 명단에 저장
            uint256 prizePerWinner = address(this).balance / winners.length; // 총 상금을 동일득표로 인한 공동동우승자 수로 나눔

            for (uint256 i = 0; i < winners.length; i++) {  //우승자 수만큼 반복, 우승자들의 주소로 분배된 상금 전송
                (bool success, ) = winners[i].call{value: prizePerWinner}("");  
                require(success, "Failed to send ETH to a winner.");
                emit winnerAddress(winners[i]);
            }
            for (uint256 i = 0; i < totalPlayer; i++) {  //해당라운드에서 진행한 투표를 초기화
                votes[i]=0;
            }
            VotedNumber = 0;  //투표를 마친 사람수도 모두 0으로 초기화
            ++round;  //라운드 증가
            gameStarted = false;  //게임 비활성화
        } else {  //실패 시 돈을 전송한 사람들에게 다시 전달
            for (uint256 i = 0; i < totalPlayer; i++) { 
                emit paidAddress(nameArray[i], msg.value);
            }
        }
    }

    function getWinners() private view returns (address[] memory) {  //우승자를 가려내는 함수
        uint256 maxVotes = 0;  //최다 득표자 저장함수

        for (uint256 i = 0; i < totalPlayer; i++) {  //모든 플레어의들의 득표수를 비교하여 최대 득표자를 변경
            if (votes[i] > maxVotes) {  
                maxVotes = votes[i];
            }
        }

        uint256 count = 0;  //우승자 수를 저장할 변수

        for (uint256 i = 0; i <totalPlayer; i++) {  //최다득표자와 플레이들의 득표수를 비교하여 같은 값이 나온 만큼 우승자수 증가
            if (votes[i] == maxVotes) {
                count++;
            }
        }

        address[] memory winners = new address[](count);  //우승자수만큼 주소형 배열 초기화
        uint256 index = 0;

        for (uint256 i = 0; i < totalPlayer; i++) {  //최다 득표를 한 플레이어들을 우승자 배열에 저장
            if (votes[i] == maxVotes) {
                winners[index] = nameArray[i];
                index++;
            }
        }

        return winners;  //우승자 주소 배열 반환
    }
    function setSecretKey(string memory _key1, uint _key2) public onlyOwner() { //게임의 키값 변경
        key1 = _key1;
        key2 = _key2;
    }

    function getSecretKey() public view onlyOwner() returns (string memory, uint) {  //owner에게만 보이는 게임의 키값 반환
        return (key1, key2);
    }
    function getRound() public view returns (uint256) {  //현재 라운드를 반환
        return round;
    }
    function getvotedNumber() public view returns (uint256) {    //현재 투표를 끝낸 사람의 수를 반환
        return VotedNumber;
    }
    function gettotalPlayer() public view returns (uint256) {   //현재 게임에 참여한 플레이어 수를 반환
        return totalPlayer;
    }
    function getBalance() public view returns (uint256) {   //현재 쌓인 상금을 반환
        return address(this).balance;
    }
    function getRequiredValue() public view returns (uint256) {   //현재 쌓인 상금을 반환
        return requiredValue;
    }

}



