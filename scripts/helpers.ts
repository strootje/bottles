import { stream as FastGlob } from 'fast-glob';
import { readFile } from 'fs';
import { resolve } from 'path';
import { promisify } from 'util';
const ReadFileAsync = promisify(readFile);

export interface BottleFile {
	name: string;
}

export interface TemplateFile {
	title: string;
}

export function SrcDir(...paths: string[]): string {
	return BaseDir('src', ...paths);
}

export function DistDir(...paths: string[]): string {
	return BaseDir('dist', ...paths);
}

export function GetBottlesJsonAsync(): Promise<BottleFile[]> {
	return MergeJsonFilesFromFolder(SrcDir(), './*.json');
}

export function GetTemplatesJsonAsync(): Promise<TemplateFile[]> {
	return MergeJsonFilesFromFolder(SrcDir('portainer'), '**/*.json');
}

export async function ReadJsonFileAsync<T extends {}>(path: string): Promise<T> {
	const raw = await ReadFileAsync(path, 'utf-8');
	const json = JSON.parse(raw) as T;
	return json;
}

export async function ReadJsonFile2Async(path: string): Promise<{}> {
	const raw = await ReadFileAsync(path, 'utf-8');
	const json = JSON.parse(raw);
	return json;
}

function BaseDir(...paths: string[]): string {
	return resolve(__dirname, '..', ...paths);
}

async function MergeJsonFilesFromFolder<T extends {}>(folder: string, pattern: string): Promise<T[]> {
	const files = FastGlob(pattern, {
		cwd: folder,
		onlyFiles: true
	});

	const results: T[] = [];
	for await (const file of files) {
		const fileAsString = file as string;
		const filepath = resolve(folder, fileAsString);
		const json = await ReadJsonFileAsync<T>(filepath);
		results.push(json[0]);
	}

	return results;
}
