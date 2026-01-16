const Sequelize = require('sequelize');

module.exports = class UserCommunity extends Sequelize.Model {
    static init(sequelize) {
        return super.init({
        }, {
            sequelize,
            timestamps: false,
            underscored: true,
            modelName: 'UserCommunity',
            tableName: 'user_community',
            paranoid: false,
            charset: 'utf8',
            collate: 'utf8_general_ci',
        });
    }

    static associate(db) {

    }
};