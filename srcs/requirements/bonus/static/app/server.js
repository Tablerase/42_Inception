const express = require('express');
const app = express();
const port = 7500;

// Express serving static files form directory named: public
app.use(express.static('public'));

// Express listening on port variable define above
app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});