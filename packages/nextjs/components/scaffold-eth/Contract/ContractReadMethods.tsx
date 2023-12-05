import { ReadOnlyFunctionForm } from "./ReadOnlyFunctionForm";
import { Abi, AbiFunction } from "abitype";
import { Contract, ContractName, GenericContract, InheritedFunctions } from "~~/utils/scaffold-eth/contract";

export const ContractReadMethods = ({
  deployedContractData,
  contractName,
}: {
  deployedContractData: Contract<ContractName>;
  contractName: ContractName;
}) => {
  if (!deployedContractData) {
    return null;
  }
  console.log(`contractName \n`, contractName);

  const mockTokenReadFunctionNames: string[] = ["getBalance"];
  const testContractReadFunctionNames: string[] = ["balanceOf"];

  // const
  // const testContractFunctionNames

  const functionsToDisplay = (
    ((deployedContractData.abi || []) as Abi).filter(part => {
      return part.type === "function";
    }) as AbiFunction[]
  )
    .filter(fn => {
      const isQueryableWithParams =
        (fn.stateMutability === "view" || fn.stateMutability === "pure") && fn.inputs.length > 0;

      return isQueryableWithParams;
    })
    .filter(fn => {
      switch (contractName) {
        case "MockToken": {
          return mockTokenReadFunctionNames.includes(fn.name);
        }
        case "TestContract": {
          return testContractReadFunctionNames.includes(fn.name);
        }
      }
    })
    .map(fn => {
      return {
        fn,
        inheritedFrom: ((deployedContractData as GenericContract)?.inheritedFunctions as InheritedFunctions)?.[fn.name],
      };
    })
    .sort((a, b) => (b.inheritedFrom ? b.inheritedFrom.localeCompare(a.inheritedFrom) : 1));

  if (!functionsToDisplay.length) {
    return <>No read methods</>;
  }

  return (
    <>
      {functionsToDisplay.map(({ fn, inheritedFrom }) => (
        <ReadOnlyFunctionForm
          contractAddress={deployedContractData.address}
          abiFunction={fn}
          key={fn.name}
          inheritedFrom={inheritedFrom}
        />
      ))}
    </>
  );
};
