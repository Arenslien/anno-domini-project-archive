const express = require("express");

const app = express();

app.set("port", process.env.PORT || 3000);


app.get("/", (req, res) => {
    res.send("index");
});

app.get("/test", (req, res) => {
    test_json = {
        "name": "Sunghun Jung",
        "major": "Data Technology",
        "Age": 22,
    };
    res.json(test_json);
});




app.listen(app.get("port"), () => {
    console.log(`${app.get("port")}번 포트에서 서버 구동중`);
});