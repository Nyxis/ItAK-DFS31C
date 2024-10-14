const config = {
    openWeatherMapApiKey: '46363c27fe0c9d89fcaa652078152d94',
  };
  
  function setApiKey(key) {
    if (!key) {
      throw new Error('La clé API OpenWeatherMap est requise');
    }
    config.openWeatherMapApiKey = key;
  }
  
  module.exports = {
    config,
    setApiKey,
  };