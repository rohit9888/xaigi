
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Wallet.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

interface wallet {
    function destroy() external ;

}

contract walletFactory is Initializable{
    address admin;
    event CreateWallet(address indexed  userWallet);

    modifier onlyAdmin() {
        require(msg.sender == owner , "not an admin");
        _;
    }

    function initializer(address _admin)  initializer(_admin){
        admin = _admin;
    }
    function createWallet(address _user) external returns(address){
        address userWallet = address(new SmartWallet{salt : bytes32("Hello World")}(_user, admin));
        emit CreateWallet(userWallet);
        return userWallet;
        
    }

    function destroyWallet(address userWallet) external returns(bool){
        wallet(userWallet).destroy();
    }
  


}
