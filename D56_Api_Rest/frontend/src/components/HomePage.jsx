const buttonStyle = {
    padding: '10px 20px',
    fontSize: '16px',
    margin: '10px',
    cursor: 'pointer',
};

const HomePage = ({ setCurrentPage }) => {
    return (
        <div style={{ textAlign: 'center' }}>
            <div>
                <button
                    style={buttonStyle}
                    onClick={() => setCurrentPage('hello')}
                > 
                 Hello World
                </button>

                <button style={buttonStyle} 
                onClick={() => setCurrentPage('weather')}
                >
                    Meteo
                </button>
            </div>
        </div>
    );
};

export default HomePage