# ARM-Pipelined-CPU:

This repository contains the implementation of a 64-bit ARM CPU with pipelining. The CPU is designed to execute the same instructions as in Project 3, with the addition of a delay slot after each load and branch instruction. The implementation also includes data forwarding logic to ensure proper data dependencies between instructions.

## Table of Contents:
* [Introduction](https://github.com/hwangsab/ARM-Pipelined-CPU/blob/main/README.md#introduction)
* [Project Overview](https://github.com/hwangsab/ARM-Pipelined-CPU/blob/main/README.md#project-overview)
* [Installation](https://github.com/hwangsab/ARM-Pipelined-CPU/blob/main/README.md#installation)
* [Testing](https://github.com/hwangsab/ARM-Pipelined-CPU/blob/main/README.md#testing)

## Introduction:
The goal of this project is to design and implement a 64-bit ARM CPU with pipelining. Pipelining improves the performance of the CPU by overlapping the execution of multiple instructions. This project builds upon the previous three projects: the file register, the ALU, and the single-cycle CPU. It incorporates the fully functional components from those projects to create a complete pipelined CPU.

## Project Overview: 
The project involves designing and implementing a pipelined CPU with the following features:
1. Instruction Set: The CPU is required to support the same instruction set as Project 3. The instruction set details will be provided separately.
2. Pipelining: The CPU is pipelined to improve performance. Pipelining allows multiple instructions to be processed simultaneously by dividing the instruction execution into sequential stages.
3. Delay Slot: The CPU incorporates a delay slot after each load and branch instruction. The delay slot refers to the space in the pipeline after a branch instruction, where the next instruction is fetched and executed regardless of whether the branch is taken or not.
4. Data Forwarding: The CPU is responsible for implementing data forwarding. Data forwarding ensures that the correct values are available to instructions that require them, even in the presence of data hazards.
5. Register File: The CPU utilizes a register file to store and manipulate data during instruction execution. Special consideration should be given to register 31, which is required to always hold the value 0, regardless of what is written to that register.
6. Handling Different Instructions: Not all instructions write to registers, and the register IDs may be located at different positions within the instruction word. These factors should be carefully considered during the design and implementation.

## Installation:
To use the notebooks in this repository, follow the steps below:

  1. Clone the repository to your local machine using the command:   
  `git clone https://github.com/your-username/ARM-Pipelined-CPU.git`
       
  2. Build the CPU project using the provided build system or build script.
        
  3. Once the CPU is built, you can execute programs written in the ARM instruction set by providing the program binary or assembly file as input to the CPU.
        
  4. Monitor the execution of the program and observe the modified register values at the end of the execution.

## Testing:
To ensure the correctness and functionality of the pipelined CPU implementation, a set of sample instruction sequences will be provided separately. These instruction sequences are designed to test various aspects of the CPU, including data forwarding, branching, and handling different instructions.

To test the CPU:
1. Prepare the test program using either a binary or assembly format.
2. Load the test program into the CPU.
3. Execute the program and observe the register values at the end of the execution.
4. Compare the obtained register values with the expected values to verify the correctness of the CPU implementation.
