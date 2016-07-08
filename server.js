// Reactatron.Server

const path = require('path')
const express = require('express')
const bodyParser = require('body-parser')
const Reactatron = require('.')

const Server = express()

const srcPath   = path.join(process.cwd(), 'src')
const publicDir = path.join(process.cwd(), 'dist/client')
const cachePath = path.join(process.cwd(), 'temp/cache')

console.log('publicDir', publicDir)

Server.set('port', process.env.PORT || '3000')


if (process.env.NODE_ENV === "development"){
  const babel = require('babel-core');
  Server.use((req, res, next) => {
    console.log('recompiling')
    Reactatron.compile(next)
  });
}


Server.use(bodyParser.json())
Server.use(express.static(publicDir))

Server.get('/*', (request, response) => {
  response.sendFile(publicDir + '/index.html');
});

Server.start = (callback) => {
  Server.listen(Server.get('port'), () => {
    if (callback) callback(Server);
  });
};

module.exports = Server
