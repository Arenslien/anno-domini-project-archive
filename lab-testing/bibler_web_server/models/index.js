// Import modules
const Sequelize = require('sequelize');
const env = process.env.NODE_ENV || 'development';
const config = require('../config/config.json')[env];
const db = {};

// Import all models 
const User = require('./user');
const Community = require('./community');
const UserCommunity = require('./user_community');

// sequelize 생성
let sequelize = new Sequelize(config.database, config.username, config.password, config);

// db attribute 추가
db.sequelize = sequelize;
db.User = User;
db.Community = Community;
db.UserCommunity = UserCommunity;

// db model 초기화 & 관계 설정
User.init(sequelize);
Community.init(sequelize);
UserCommunity.init(sequelize);

User.associate(db);
Community.associate(db);
UserCommunity.associate(db);

// Export DB
module.exports = db;
