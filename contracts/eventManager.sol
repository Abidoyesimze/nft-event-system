// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EventManager is AccessControl {
    IERC721 public nftContract;
    bytes32 public constant EVENT_MANAGER_ROLE = keccak256("EVENT_MANAGER_ROLE");

    struct Event {
        string name;
        uint256 capacity;
        mapping(address => bool) registeredUser;
        uint256[] registeredUserIds;
        uint256 registrationCounts;
    }

    mapping(uint256 => Event) public events;
    uint256 public nextEventId;

    event EventCreated(uint256 indexed eventId, string eventName, uint256 eventCapacity);
    event UserRegistered(uint256 indexed eventId, address indexed user);

    constructor(address _nftContractAddress) {
        nftContract = IERC721(_nftContractAddress);  // The address of the NFT contract
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(EVENT_MANAGER_ROLE, msg.sender);  // Grant event manager role
    }

    function createEvent(string memory _name, uint256 _capacity) public {
        require(hasRole(EVENT_MANAGER_ROLE, msg.sender), "Caller is not an event manager");

        events[nextEventId].name = _name;
        events[nextEventId].capacity = _capacity;
        events[nextEventId].registrationCounts = 0;

        emit EventCreated(nextEventId, _name, _capacity);
        nextEventId++;
    }

    function registerEvent(uint256 eventId) public {
        require(events[eventId].capacity > events[eventId].registrationCounts, "Event full");
        require(verifyNftOwnership(msg.sender), "You must own the NFT to register");

        events[eventId].registeredUser[msg.sender] = true;
        events[eventId].registrationCounts++;
        events[eventId].registeredUserIds.push(uint256(uint160(msg.sender)));  // Convert address to uint256

        emit UserRegistered(eventId, msg.sender);  // Emit user registration event
    }

    // Verify if the user owns any NFT from the NFT contract
    function verifyNftOwnership(address user) public view returns (bool) {
        return nftContract.balanceOf(user) > 0;  // Ensure the user owns at least one NFT
    }

    function getEventDetails(uint256 eventId) public view returns (
        string memory name,
        uint256 capacity,
        uint256 registrationCounts
    ) {
        Event storage event_ = events[eventId];
        return (event_.name, event_.capacity, event_.registrationCounts);
    }
}
