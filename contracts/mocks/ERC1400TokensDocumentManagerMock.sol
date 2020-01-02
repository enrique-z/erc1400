pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/GSN/Context.sol";
import "openzeppelin-solidity/contracts/access/Roles.sol";

import "../token/ERC1820/ERC1820Implementer.sol";

import "../token/ERC1400Partition/IERC1400Partition.sol";
import "../token/ERC1400Raw/IERC1400TokensDocumentManager.sol";


contract ERC1400TokensDocumentManagerMock is IERC1400TokensDocumentManager, Context, ERC1820Implementer {
  using SafeMath for uint256;

  string constant internal ERC1400_TOKENS_DOCUMENT_MANAGER = "ERC1400TokensDocumentManager";

  using Roles for Roles.Role;

  event DocumentManagerAdded(address indexed account);
  event DocumentManagerRemoved(address indexed account);

  Roles.Role private _documentManagers;

  struct Doc {
    string docURI;
    bytes32 docHash;
  }

  // Mapping for token URIs.
  mapping(bytes32 => Doc) internal _documents;

  modifier onlyDocumentManager() {
    require(isDocumentManager(_msgSender()), "DocumentManagerRole: caller does not have the DocumentManager role");
    _;
  }


  constructor() public {
    _addDocumentManager(_msgSender());
    ERC1820Implementer._setInterface(ERC1400_TOKENS_DOCUMENT_MANAGER);
  }

  /**
   * @dev Access a document associated with the token.
   * @param name Short name (represented as a bytes32) associated to the document.
   * @return Requested document + document hash.
   */
  function getDocument(bytes32 name) external view returns (string memory, bytes32) {
    require(bytes(_documents[name].docURI).length != 0); // Action Blocked - Empty document
    return (
      _documents[name].docURI,
      _documents[name].docHash
    );
  }

  /**
   * @dev Associate a document with the token.
   * @param from Address of the document manager.
   * @param name Short name (represented as a bytes32) associated to the document.
   * @param uri Document content.
   * @param documentHash Hash of the document [optional parameter].
   */
  function setDocument(address from, bytes32 name, string calldata uri, bytes32 documentHash) external {
    _documents[name] = Doc({
      docURI: uri,
      docHash: documentHash
    });
  }


  function isDocumentManager(address account) public view returns (bool) {
    return _documentManagers.has(account);
  }

  function addDocumentManager(address account) public onlyDocumentManager {
    _addDocumentManager(account);
  }

  function renounceDocumentManager() public {
    _removeDocumentManager(_msgSender());
  }

  function _addDocumentManager(address account) internal {
    _documentManagers.add(account);
    emit DocumentManagerAdded(account);
  }

  function _removeDocumentManager(address account) internal {
    _documentManagers.remove(account);
    emit DocumentManagerRemoved(account);
  }


}