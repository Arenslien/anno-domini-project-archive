const express = require('express');
const { Community } = require('../models');

const router = express.Router();


router.get('/', async (req, res, next) => {
    res.send('<h1>Main</h1>');
});

router.post('/create_community', async (req, res, next) => {
    console.log(req.body);
    try {
        const community = Community.create({
            name: req.body.name,
            admin_id: req.body.id,
            affiliation: req.body.affiliation,
        });
    } catch(err) {
        console.error(err);
    }

    res.send('good');   
});



module.exports = router;