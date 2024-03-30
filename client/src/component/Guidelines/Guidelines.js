import React from "react";
import Navbar from "../Navbar/Navigation";

import "./Guidelines.css";

const Guidelines = () => {
    return (
        <>
            <Navbar />
            <div className="container">
                <h1>How to Vote</h1>
                <p>
                    Welcome to our blockchain-based voting platform! Follow these simple
                    guidelines to cast your vote securely using MetaMask and your Ethereum wallet:
                </p>
                <ol>
                    <li>Make sure you have MetaMask installed in your browser.</li>
                    <li>Connect your Ethereum wallet to MetaMask.</li>
                    <li>Log in to our website using your MetaMask account.</li>
                    <li>Browse through the list of candidates and their profiles.</li>
                    <li>Select your preferred candidate by clicking on their name.</li>
                    <li>Confirm your selection and sign the transaction in MetaMask.</li>
                    <li>Wait for the transaction to be confirmed on the Ethereum network.</li>
                    <li>Once confirmed, your vote is recorded securely on the blockchain.</li>
                </ol>
                <p>
                    Thank you for participating in our democratic process. Your vote
                    matters!
                </p>
            </div>
        </>
    );
};

export default Guidelines;
