import { debug } from 'debug';
import { mkdir, writeFile } from 'fs';
import { promisify } from 'util';
import { DistDir, GetTemplatesJsonAsync } from './helpers';
const WriteFileAsync = promisify(writeFile);
const MkdirAsync = promisify(mkdir);
const logger = debug('bottles:scripts:build');

(async () => {

	await MkdirAsync(DistDir());

	const templates = await GetTemplatesJsonAsync();
	logger('building %s templates', templates.length);
	await WriteFileAsync(DistDir('templates.json'), JSON.stringify(templates), 'utf-8');

})();
