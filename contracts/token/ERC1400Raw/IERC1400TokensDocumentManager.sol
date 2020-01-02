/*
 * This code has not been reviewed.
 * Do not use or deploy this code before reviewing it personally first.
 */
pragma solidity ^0.5.0;

/**
 * @title IERC1400TokensDocumentManager
 * @dev IERC1400TokensDocumentManager interface
 */
interface IERC1400TokensDocumentManager {

  function getDocument(bytes32 name) external view returns (string memory, bytes32);

  function setDocument(address from, bytes32 name, string calldata uri, bytes32 documentHash) external;

}