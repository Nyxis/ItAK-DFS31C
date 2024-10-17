// Импортируем библиотеку для работы с семантическим версионированием
const semver = require('semver');

// Middleware для проверки версии API
function versionChecker(req, res, next) {
  // Получаем версию API из заголовка запроса или используем значение по умолчанию
  const version = req.get('API-Version') || '1.0.0';
  
  // Проверяем, является ли версия допустимой
  if (!semver.valid(version)) {
    return res.status(400).json({ error: 'Invalid API version format' });
  }

  // Проверяем, удовлетворяет ли версия минимальным требованиям
  if (!semver.satisfies(version, '>=1.0.0')) {
    return res.status(400).json({ error: 'Unsupported API version' });
  }

  // Если все проверки пройдены, добавляем версию в объект запроса
  req.apiVersion = version;
  // Передаем управление следующему middleware
  next();
}

// Экспортируем middleware
module.exports = versionChecker;