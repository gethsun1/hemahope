import React from 'react';
import { Web3ReactProvider } from '@web3-react/core';
import { ethers } from 'ethers';
import ContractInteraction from './components/ContractInteraction';

// Function to create a custom provider for Web3React
function getLibrary(provider) {
  return new ethers.providers.Web3Provider(provider);
}

function App() {
  return (
    <Web3ReactProvider getLibrary={getLibrary}>
      <div className="App">
        <h1>Interact with Smart Contract</h1>
        <ContractInteraction />
      </div>
    </Web3ReactProvider>
  );
}

export default App;
