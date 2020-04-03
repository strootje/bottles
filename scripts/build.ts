import { debug } from 'debug';
import { mkdir, writeFile } from 'fs';
import { promisify } from 'util';
import { DistDir, GetBottlesJsonAsync, GetTemplatesJsonAsync } from './helpers';
const WriteFileAsync = promisify(writeFile);
const MkdirAsync = promisify(mkdir);
const logger = debug('bottles:scripts:build');

(async () => {

	await MkdirAsync(DistDir());

	const bottles = await GetBottlesJsonAsync();
	logger('building %s bottles', bottles.length);
	await WriteFileAsync(DistDir('index.json'), JSON.stringify({ info: { title: 'bottles' }, data: bottles }), 'utf-8');

	const templates = await GetTemplatesJsonAsync();
	logger('building %s templates', templates.length);
	await WriteFileAsync(DistDir('templates.json'), JSON.stringify(templates), 'utf-8');

})();
