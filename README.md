EventManager Contract

Overview
The EventManager smart contract is designed to manage and facilitate the creation, registration, and organization of events. Users who hold a specific NFT can register for these events, and the contract owner or event manager can create events with a limited capacity. This contract uses AccessControl from OpenZeppelin to manage roles and permissions, ensuring that only authorized users can create events or register participants.

Features
Event Creation: Admins or event managers can create new events with a specific name and capacity.
Registration: Users who hold the required NFT can register for an event if there is available capacity.

NFT Ownership Check: Users can only register for an event if they own a specific NFT, which is verified via an external ERC721 contract.
Role-based Access Control: Only addresses with the EVENT_MANAGER_ROLE can create events, ensuring controlled event management.
Requirements

Solidity Version: ^0.8.24
OpenZeppelin Contracts: Utilizes AccessControl and IERC721 from OpenZeppelin for role management and NFT ownership verification.
Deployment
To deploy the EventManager contract, you need the address of the NFT contract (an ERC721-compliant contract) that will be used to verify ownership for event registration.

solidity

// Example deployment
EventManager eventManager = new EventManager(_nftContractAddress);
Functions
Constructor

solidity

constructor(address _nftContractAddress)

Initializes the contract with the address of an NFT contract used to verify ownership.
Grants the DEFAULT_ADMIN_ROLE and EVENT_MANAGER_ROLE to the contract deployer.
createEvent

solidity
function createEvent(string memory _name, uint256 _capacity) public

Allows users with the EVENT_MANAGER_ROLE to create a new event.
Takes the event name and capacity as input parameters.
Emits the EventCreated event.
registerEvent

solidity:
function registerEvent(uint256 eventId) public

Allows users to register for an event if:
They own the required NFT.
The event is not full.
Increases the registration count for the event.
Adds the user’s address to the list of registered users for the event.
Emits the userRegistered event.
verifyNftOwnership
solidity

function verifyNftOwnership(uint256 tokenId) public view returns (bool)

Checks if the caller owns the NFT with the given tokenId.
Returns true if the caller owns the NFT; otherwise, returns false.
getEventDetails

solidity

function getEventDetails(uint256 eventId) public view returns (
    string memory name,
    uint256 capacity,
    uint256 registrationCounts
)
Returns the event details including the event's name, capacity, and current number of registrations.
setEventManager

solidity

function setEventManager(address _eventManager) external onlyOwner

Allows the contract owner to set the address of the Event Manager.
Events
EventCreated

solidity

event EventCreated(uint256 indexed eventId, string eventName, uint256 eventCapacity);

Emitted when a new event is created.
userRegistered
solidity
Copy code
event userRegistered(uint256 indexed eventId, address indexed user);
Emitted when a user registers for an event.
Usage
Step 1: Deploy the EventManager Contract
Deploy the contract with the address of the NFT contract that will be used to verify ownership.

Step 2: Create Events
The contract owner or an address with the EVENT_MANAGER_ROLE can create events by calling the createEvent function. Provide the name of the event and the maximum number of participants (capacity).

solidity

eventManager.createEvent("Blockchain Summit", 100);

Step 3: Register for Events
Users can register for an event if they hold the specified NFT and the event is not full. The registerEvent function checks the user’s ownership of the NFT before registering them.

solidity

eventManager.registerEvent(0);  // Registers the user for event ID 0

Example Flow
The owner deploys the EventManager contract with the NFT contract address.
An admin or event manager creates an event with a name like "Web3 Conference" and a capacity of 50.
Users who own the NFT can call registerEvent to sign up for the event.
The contract verifies if the user owns the required NFT. If successful, the user is registered for the event.
Security Considerations
Role Management: Only authorized users with the EVENT_MANAGER_ROLE can create new events. The admin can add or revoke roles as necessary using the grantRole and revokeRole functions from OpenZeppelin’s AccessControl.

NFT Verification: The contract integrates with an external ERC721 contract to ensure users are eligible to register for events based on their NFT ownership.
