// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

abstract contract Election {
    address public admin;
    uint256 candidateCount;
    uint256 voterCount;
    bool start;
    bool end;

    constructor() {
        // Initilizing default values
        admin = msg.sender;
        candidateCount = 0;
        voterCount = 0;
        start = false;
        end = false;
    }

    function getAdmin() public view returns (address) {
        // Returns account address used to deploy contract (i.e. admin)
        return admin;
    }

    modifier onlyAdmin() {
        // Modifier for only admin access
        require(msg.sender == admin);
        _;
    }

    // Custom SHA-256 implementation
    function customSHA256(
        string memory input
    ) internal pure returns (string memory) {
        bytes memory inputData = bytes(input);
        bytes memory hash = new bytes(64); // SHA-256 hash length is 64 bytes

        for (uint256 i = 0; i < inputData.length; i++) {
            hash[i % 64] ^= inputData[i];
            hash[i % 64] = bytes1(uint8(hash[i % 64]) << 1);
            if (i % 64 == 63) {
                hash[i % 64] = bytes1(uint8(hash[i % 64]) >> 1);
            }
        }

        // Convert the bytes32 hash to a hexadecimal string
        bytes memory hexChars = "0123456789abcdef";
        bytes memory result = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            result[i * 2] = hexChars[uint8(hash[i] >> 4)];
            result[i * 2 + 1] = hexChars[uint8(hash[i] & 0x0f)];
        }
        return string(result);
    }

    // Modeling a candidate
    struct Candidate {
        uint256 candidateId;
        string header;
        string slogan;
        uint256 voteCount;
    }
    mapping(uint256 => Candidate) public candidateDetails;

    // Adding new candidates
    function addCandidate(
        string memory _header,
        string memory _slogan
    )
        public
        // Only admin can add
        onlyAdmin
    {
        Candidate memory newCandidate = Candidate({
            candidateId: candidateCount,
            header: _header,
            slogan: _slogan,
            voteCount: 0
        });
        candidateDetails[candidateCount] = newCandidate;
        candidateCount += 1;
    }

    // Modeling an Election's Details
    struct ElectionDetails {
        string adminName;
        string adminEmail;
        string adminTitle;
        string electionTitle;
        string organizationTitle;
    }
    ElectionDetails electionDetails;

    function setElectionDetails(
        string memory _adminName,
        string memory _adminEmail,
        string memory _adminTitle,
        string memory _electionTitle,
        string memory _organizationTitle
    )
        public
        // Only admin can add
        onlyAdmin
    {
        electionDetails = ElectionDetails(
            _adminName,
            _adminEmail,
            _adminTitle,
            _electionTitle,
            _organizationTitle
        );
        start = true;
        end = false;
    }

    // Get Elections details
    function getElectionDetails()
        public
        view
        returns (
            string memory adminName,
            string memory adminEmail,
            string memory adminTitle,
            string memory electionTitle,
            string memory organizationTitle
        )
    {
        return (
            electionDetails.adminName,
            electionDetails.adminEmail,
            electionDetails.adminTitle,
            electionDetails.electionTitle,
            electionDetails.organizationTitle
        );
    }

    // Get candidates count
    function getTotalCandidate() public view returns (uint256) {
        // Returns total number of candidates
        return candidateCount;
    }

    // Get voters count
    function getTotalVoter() public view returns (uint256) {
        // Returns total number of voters
        return voterCount;
    }

    // Sort candidates based on their vote count using Bubble Sort
    function sortCandidatesByVoteCount() public onlyAdmin {
        uint256 n = candidateCount;
        Candidate memory temp;
        for (uint256 i = 0; i < n - 1; i++) {
            for (uint256 j = 0; j < n - i - 1; j++) {
                if (
                    candidateDetails[j].voteCount <
                    candidateDetails[j + 1].voteCount
                ) {
                    temp = candidateDetails[j];
                    candidateDetails[j] = candidateDetails[j + 1];
                    candidateDetails[j + 1] = temp;
                }
            }
        }
    }

    // Modeling a voter
    struct Voter {
        address voterAddress;
        string name;
        string phone;
        bool isVerified;
        bool hasVoted;
        bool isRegistered;
    }
    address[] public voters; // Array of address to store address of voters
    mapping(address => Voter) public voterDetails;

    // Request to be added as a voter
    function registerAsVoter(string memory _name, string memory _phone) public {
        // Hashing the voter's name using customSHA256
        string memory name = customSHA256(_name);
        string memory phone = customSHA256(_phone);

        Voter memory newVoter = Voter({
            voterAddress: msg.sender,
            phone: phone, // Store the hashed phone
            name: name, // Store the hashed name
            isVerified: false,
            hasVoted: false,
            isRegistered: true
        });
        voterDetails[msg.sender] = newVoter;
        voters.push(msg.sender);
        voterCount += 1;
    }

    // Verify voter
    function verifyVoter(
        bool _verifedStatus,
        address voterAddress
    )
        public
        // Only admin can verify
        onlyAdmin
    {
        voterDetails[voterAddress].isVerified = _verifedStatus;
    }

    // Vote
    function vote(uint256 candidateId) public {
        require(voterDetails[msg.sender].hasVoted == false);
        require(voterDetails[msg.sender].isVerified == true);
        require(start == true);
        require(end == false);
        candidateDetails[candidateId].voteCount += 1;
        voterDetails[msg.sender].hasVoted = true;
    }

    // End election
    function endElection() public onlyAdmin {
        end = true;
        start = false;
    }

    // Get election start and end values
    function getStart() public view returns (bool) {
        return start;
    }

    function getEnd() public view returns (bool) {
        return end;
    }
}
