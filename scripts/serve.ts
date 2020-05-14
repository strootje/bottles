import { watch as Chokidar } from 'chokidar';
import { debug } from 'debug';
import * as Express from 'express';
import { resolve } from 'path';
import { ReadJsonFileAsync, SrcDir } from './helpers';
const logger = debug('bottles:scripts:serve');

interface ListOfFiles {
	[key: string]: {};
}

(async () => {

	const config = {
		host: '0.0.0.0',
		port: 3000
	};

	const server = Express();
	const bottles: ListOfFiles = {};
	server.get('/templates.json', (_, res) => res.json(Object.values(Object.keys(bottles).map(p => bottles[p]))));

	server.listen(config.port, config.host, () => {
		logger('server started at http://%s:%s', config.host, config.port);

		const watcher = Chokidar('**/*.json', {
			cwd: SrcDir('portainer')
		});

		watcher.on('add', async filename => {
			try {
				const path = resolve(SrcDir('portainer'), filename);
				const json = await ReadJsonFileAsync(path);

				if (!bottles[filename]) {
					bottles[filename] = json;
					logger('added %s', filename);
				}
			} catch {
				// empty...
			}
		});

		watcher.on('change', async filename => {
			try {
				const path = resolve(SrcDir('portainer'), filename);
				const json = await ReadJsonFileAsync(path);

				if (bottles[filename]) {
					bottles[filename] = json;
					logger('updated %s', filename);
				}
			} catch {
				// empty...
			}
		});

		watcher.on('unlink', filename => {
			try {
				if (bottles[filename]) {
					delete bottles[filename];
					logger('removed %s', filename);
				}
			} catch {
				// empty...
			}
		});
	});

})();
