// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract GLDToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }
}

contract SmartWallet {
    using SafeERC20 for IERC20;

    receive() external payable {}

    mapping(address => uint256) tokenBalances;
    address owner;
    address admin;

    constructor(address _owner, address _admin) {
        owner = _owner;
        admin = _admin;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "not an owner");
        _;
    }

    function sendToken(
        address _token,
        address to,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        require(_token != address(0), "Invalid token address");
        require(to != address(0), "Invalid recipient address");

        // Transfer tokens using the ERC20 transfer function
        (bool success, ) = _token.call(
            abi.encodeWithSignature("transfer(address,uint256)", to, _amount)
        );

        if (!success) {
            revert("Token transfer failed");
        }

        return true;
    }

    function receiveToken(address _token, uint256 _amount)
        external
        returns (bool)
    {
        (bool success, bytes memory data) = _token.call(
            abi.encodeWithSignature(
                "transferFrom(address, address, uint256)",
                msg.sender,
                address(this),
                _amount
            )
        );
        if (!success) {
            revert("transaction failed");
        }
        return true;
    }

    function sendEther(uint256 amount, address to)
        external
        onlyOwner
        returns (bool)
    {
        require(address(this).balance >= amount, "insufficient balance");
        (bool success, bytes memory data) = to.call{value: amount, gas: 21000}(
            ""
        );
    }

    function destroy() public {
        require(tx.origin == admin, "caller is not the owner");
        selfdestruct(payable(owner));
    }
}


