const {ethers} = require("hardhat")
require("dotenv").config()

async function main(){
  const getContract =  await ethers.getContractFactory("NftSale")

  const deployContract = await getContract.deploy(process.env.BASE_URI, process.env.CONTRACT_ADDRESS)

 await deployContract.deployed()

 console.log(deployContract.address)

}

 main().then(()=>{
  console.log("Deploued Successfully")
  process.exit(0)
 }).catch((error)=>{
  console.log("error deploying contract", error.message)
  process.exit(1)
 })