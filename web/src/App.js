import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Battle of the Dragons Revived</h1>
        <h2>Website Coming Soon</h2>
        <div className="image-container">
          <img 
            src="/assets/images/BOTDR_BANNER.jpg" 
            alt="Battle of the Dragons Revived Banner" 
            className="banner-image"
          />
        </div>
        <p>We're working hard on bringing you an awesome experience. Stay tuned!</p>
        <p>In the meantime, you can join our community and check out our project below:</p>

        <div className="links">
          <a 
            href="https://discord.gg/YOUR_DISCORD_LINK" 
            className="link-button" 
            target="_blank" 
            rel="noopener noreferrer"
          >
            Join our Discord
          </a>

          <a 
            href="https://github.com/YOUR_GITHUB_REPO" 
            className="link-button" 
            target="_blank" 
            rel="noopener noreferrer"
          >
            View our GitHub
          </a>
        </div>
      </header>
    </div>
  );
}

export default App;
