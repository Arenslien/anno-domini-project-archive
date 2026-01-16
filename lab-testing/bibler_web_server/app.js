const express = require('express');
const morgan = require('morgan');
const path = require('path');


// 시퀄라이즈와 라우터 가져오기
const { sequelize } = require('./models'); 
const indexRouter = require('./routes');


const app = express();


app.set('port', 3000);

// DB와 서버 연결
sequelize.sync({ force: true })
    .then(() => {
        console.log("DB 연결 성공");
    })
    .catch((err) => {
        console.error(err);
    });

// 미들웨어 사용
app.use(morgan('dev'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// 라우터 연결
app.use('/', indexRouter);

// 에러 처리
// app.use((req, res, next) => {
//     const error = new Error(`${req.method} ${req.url} 라우터가 없습니다.`);
//     error.status = 404;
//     next(error);
// });

// app.use((err, req, res, next) => {
//     res.locals.message = err.message;
//     res.locals.error = process.env.NODE_ENV !== 'production' ? err : {};
//     res.status(err.status || 500);
//     res.render('error');
// });

// 서버 시작
app.listen(app.get('port'), () => {
    console.log('START WEB SERVER');
});



