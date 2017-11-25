require('coffeescript/register')

const coffeeCoverage = require('coffee-coverage');
const coverageVar = coffeeCoverage.findIstanbulVariable();
const writeOnExit = coverageVar == null ? true : null;

coffeeCoverage.register({
    instrumentor: 'istanbul',
    basePath: process.cwd(),
    exclude: ['/test', '/node_modules', '/.git', '/gulpfile.litcoffee'],
    coverageVar: coverageVar,
    writeOnExit: writeOnExit ? ((_ref = process.env.COFFEECOV_OUT) != null ? _ref : 'coverage/coverage-coffee.json') : null,
    initAll: (_ref = process.env.COFFEECOV_INIT_ALL) != null ? (_ref === 'true') : true
});

// Setup chai
const chai = require('chai')
global.expect = chai.expect
chai.should()
chai.use(require('sinon-chai'))

// Setup sinon
global.sinon = require('sinon')
