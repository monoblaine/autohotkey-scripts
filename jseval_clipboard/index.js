const nodeEval = require('eval');
(async function main () {
    const clipboard = (await import('clipboardy')).default;
    let script = clipboard.readSync().trim().replace(/\r?\n *\/\/[^\r\n]*/, '');
    if (!script.includes('return ')) {
        script = `return ${script};`;
    }
    const result = nodeEval(`
let result = (function () { ${script} })();
if (result === null || typeof result === 'undefined') {
    result = 'null or undefined';
}
else if (typeof result !== 'string') {
    result = result.toString();
}
module.exports = result;
`, true);
    process.stdout.write(result);
})();
