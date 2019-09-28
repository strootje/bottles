import { resolve } from 'path';

export class Path {
	private static Base(...path: string[]) {
		return resolve(__dirname, '..', '..', ...path);
	}

	public static Src(...path: string[]) {
		return Path.Base('src', ...path);
	}

	public static Dist(...path: string[]) {
		return Path.Base('dist', ...path);
	}
}
