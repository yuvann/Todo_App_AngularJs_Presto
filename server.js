const express = require('express')
const cors = require('cors')
const app = express()
app.use(cors())
app.get('/time', (req, res) =>{
  var date = new Date().toISOString()
  res.send(date)
})


app.get('/', (req, res) =>{
 res.sendfile('index.html');
})


app.listen(3000, (err) => {
  if (err) {
    console.log('Error in starting server: ', err)
  }
  else {
    console.log('Listening on PORT 3000')
  }
})
