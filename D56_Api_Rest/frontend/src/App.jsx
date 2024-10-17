import React, { useState } from "react";
import HomePage from './components/HomePage';
import HelloWorld from './components/HelloWorld'
import LocationWeather from './components/LocationWeather'

const appStyle = {
  fontFamily: 'Arial, sans-serif',
  maxWidth: '100%',
  margin: 'auto',
  padding: '20px',
  backgroundColor: 'white',
  color: 'black',
  textAlign: 'center',
};

const buttonStyle = {
  padding: '10px 20px',
  fontSize: '16px',
  margin: '10px',
  cursor: 'pointer',
};

const headingStyle = {
  color: 'blue',
};

const App = () => {
  const [currentPage, setCurrentPage] = useState('home');

  const renderPage = () => {
    switch (currentPage) {
      case 'hello':
        return <HelloWorld/>;
      case 'weather':
        return <LocationWeather/>;
      default:
        return <HomePage setCurrentPage={setCurrentPage} />
    }
  };

  return (
    <div style={appStyle}>
      <h1 style={headingStyle}>API Test Application</h1>
      {currentPage !== 'home' && (
        <button onClick={() => setCurrentPage('home')} style={buttonStyle}>Return to Home Page</button>
      )}
      {renderPage()}
    </div>
  )
};

export default App;