import { stream } from 'fast-glob';
import { writeFile, mkdir } from 'fs';
import { Path } from '../utils/Path';

interface Template {
}

(async () => {

	const basepath = Path.Src('portainer');
	const files = stream(`**/*.json`, { cwd: basepath });

	let result: Template[] = [];
	for await (const file of files) {
		try {
			const filepath = `${basepath}/${file}`;
			console.log(`processing ${file}`);

			const filecontent =  require(filepath) as Template[];
			result = [ ...result, ...filecontent ];
		} catch (err) {
			console.error(err);
		}
	}

	mkdir(Path.Dist(), { recursive: true }, console.error);
	writeFile(Path.Dist('templates.json'), JSON.stringify(result), console.error);

})();
