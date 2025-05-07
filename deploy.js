const {ethers , upgrades} = require ("hardhat");


async function main(){
    const SparkToken= await ethers.getContractFactory("SparkToken");
    const spark=await upgrades.deployProxy(SparkToken,[], {
        initializer : "initialize",
        kind : "uups",
    });
    await spark.waitForDeployment();
    console.log("Spark Token deployed to:",await spark.getAddress());
 }

 main().catch((error)=>{
    console.error(error);
    process.exitCode = 1;
 });
