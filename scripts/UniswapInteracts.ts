const { ethers } = require("hardhat");

async function main() {
  const uniswapRouterAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";

  const UniswapRouter = await ethers.getContractFactory("UniswapRouter");

  // Connect to the deployed contract
  const uniswapRouter = UniswapRouter.attach(uniswapRouterAddress);

  // Perform a swap (example)
  const Token1 = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";
  const Token2 = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";
  const path = [Token1, Token2];
  const amountIn = ethers.parseEther("1"); // 1 token input amount
  const amountOutMin = 0;
  const deadline = Math.floor(Date.now() / 1000) + 60 * 20; // 20 minutes from now
  const recipient = "0x2F23127369638E1AD462FEe695a549BF80260ACA";

  const tx = await uniswapRouter.swapExactTokensForTokens(
    amountIn,
    amountOutMin,
    path,
    recipient,
    deadline
  );

  console.log("Swap transaction hash:", tx.hash);

  // Fetch the amount of liquidity available for a specific pair
  const token0Address = "<Token0 Address>";
  const token1Address = "<Token1 Address>";
  const liquidity = await uniswapRouter.getReserves(
    token0Address,
    token1Address
  );
  console.log("Liquidity for the pair:", liquidity);
}

// Execute the main function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
