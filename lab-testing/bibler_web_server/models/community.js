const Sequelize = require('sequelize');

module.exports = class Community extends Sequelize.Model {
    static init(sequelize) {
        return super.init({
            name: {
                type: Sequelize.STRING(50),
                allowNull: false,
            },
            admin_id: {
                type: Sequelize.STRING(50),
                allowNull: false,
            },
            affiliation: {
                type: Sequelize.STRING(50),
                allowNull: false,
            }
        }, {
            sequelize,
            timestamps: false,
            underscored: true,
            modelName: 'Community',
            tableName: 'community',
            paranoid: false,
            charset: 'utf8',
            collate: 'utf8_general_ci',
        });
    }

    static associate(db) {
        db.Community.belongsToMany(db.User, { through: 'UserCommunity', foreignKey: 'community_id'});        
    }
};