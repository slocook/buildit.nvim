local output = require('buildit.output')

return {
    configure = function() output.run_cmd('cmake -S . -B build') end,
    build = function() output.run_cmd('cmake --build build') end,
    clean = function() output.run_cmd('cmake --build build --target clean') end,
    test = function() output.run_cmd('ctest') end
}
