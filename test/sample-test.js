const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  //it("Should return the new greeting once it's changed", async function () {
  //  const Greeter = await ethers.getContractFactory("Greeter");
  //  const greeter = await Greeter.deploy("Hello, world!");
  //  await greeter.deployed();

  //  expect(await greeter.greet()).to.equal("Hello, world!");

  //  const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

  //  // wait until the transaction is mined
  //  await setGreetingTx.wait();

  //  const tmp = await greeter.greet();

  //  console.log(tmp);

  //  expect(tmp).to.equal("Hola, mundo!");
  //});
});

const toBytes = (string) => {
  const buffer = Buffer.from(string, "utf8");
  const result = Array(buffer.length);
  for (var i = 0; i < buffer.length; i++) {
    result[i] = buffer[i];
  }
  return result;
};

describe("SignedHeader", function () {
  it("test signed header", async function () {
    const SH = await ethers.getContractFactory("SignedHeader");
    const sh = await SH.deploy();
    await sh.deployed();

    const result = await sh.sign(toBytes("abc hello"));

    //expect(result).to.equal(9);
  });
});

describe("VerifyProof", function () {
  it("test tmp", async function () {
    const VP = await ethers.getContractFactory("VerifyProof");
    const vp = await VP.deploy();
    await vp.deployed();

    const proof = Buffer.from("010101", "hex");
    const key = Buffer.from("02020202", "hex");
    const value = Buffer.from("0303030303", "hex");
    const path = "path";

    const test = await vp.getTest();
    console.log(typeof test, test.length, test);
  });
});
