package mobile.backend;

import openfl.utils.Assets;
import lime.system.System;
import haxe.io.Path;
import haxe.io.Bytes;

using StringTools;

#if android
class FileSystem
{
	/**
	 * Checks if a file or folder exists in the Assets.
	 */
	public static function exists(path:String):Bool
	{
		if (Assets.exists(path))
			return true;

		return isDirectory(path);
	}

	/**
	 * Checks if the path is a (simulated) folder within the Assets.
	 */
	public static function isDirectory(path:String):Bool
	{
		var dir:String = path.endsWith('/') ? path : path + '/';

		for (asset in Assets.list())
		{
			if (asset.startsWith(dir))
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * Returns all files and subfolders that are *directly* within this path.
	 */
	public static function readDirectory(path:String):Array<String>
	{
		var dir:String = path.endsWith('/') ? path : path + '/';
		var contents:Array<String> = [];

		for (asset in Assets.list())
		{
			if (asset.startsWith(dir))
			{
				var relativePath:String = asset.substring(dir.length);

				var slashIndex:Int = relativePath.indexOf('/');
				var itemName:String = relativePath;

				if (slashIndex != -1)
				{
					itemName = relativePath.substring(0, slashIndex);
				}

				if (!contents.contains(itemName))
				{
					contents.push(itemName);
				}
			}
		}

		return contents;
	}

	/**
	 * createDirectory is NOT supported for Assets.
	 */
	public static function createDirectory(path:String):Void
	{
		trace("Warning: createDirectory is not supported for Assets!");
	}

	/**
	 * deleteDirectory is NOT supported for Assets.
	 */
	public static function deleteDirectory(path:String):Void
	{
		trace("Warning: deleteDirectory is not supported for Assets!");
	}

	/**
	 * Attempts to delete a file from the private folder. If it does not exist, warns that deleting assets is not supported.
	 */
	public static function deleteFile(path:String):Void
	{
		#if sys
		try
		{
			var savePath:String = Path.join([System.applicationStorageDirectory, path]);
			if (sys.FileSystem.exists(savePath) && !sys.FileSystem.isDirectory(savePath))
			{
				sys.FileSystem.deleteFile(savePath);
				return;
			}
		}
		catch (e:Dynamic)
		{
		}
		#end

		trace("Warning: deleteFile failed! File not found in the private folder or attempted to delete a protected Asset.");
	}
}

class File
{
	/**
	 * Reads the contents of a text file, attempting multiple sources to avoid crashes.
	 */
	public static function getContent(path:String):String
	{
		try
		{
			if (Assets.exists(path))
			{
				var text = Assets.getText(path);
				if (text != null)
					return text;

				var bytes = Assets.getBytes(path);
				if (bytes != null)
					return bytes.toString();
			}
		}
		catch (e:Dynamic)
		{
		}

		#if sys
		try
		{
			var savePath:String = Path.join([System.applicationStorageDirectory, path]);
			if (sys.FileSystem.exists(savePath))
			{
				return sys.io.File.getContent(savePath);
			}

			if (sys.FileSystem.exists(path))
			{
				return sys.io.File.getContent(path);
			}
		}
		catch (e:Dynamic)
		{
		}
		#end

		return null;
	}

	/**
	 * Reads the bytes of a file, attempting multiple sources to avoid crashes.
	 */
	public static function getBytes(path:String):Bytes
	{
		try
		{
			if (Assets.exists(path))
			{
				var bytes = Assets.getBytes(path);
				if (bytes != null)
					return bytes;
			}
		}
		catch (e:Dynamic)
		{
		}

		#if sys
		try
		{
			var savePath:String = Path.join([System.applicationStorageDirectory, path]);
			if (sys.FileSystem.exists(savePath))
			{
				return sys.io.File.getBytes(savePath);
			}

			if (sys.FileSystem.exists(path))
			{
				return sys.io.File.getBytes(path);
			}
		}
		catch (e:Dynamic)
		{
		}
		#end

		return null;
	}

	/**
	 * Saves content in text format in the app's private directory.
	 */
	public static function saveContent(path:String, content:String):Void
	{
		var savePath:String = Path.join([System.applicationStorageDirectory, path]);

		#if sys
		try
		{
			sys.io.File.saveContent(savePath, content);
		}
		catch (e:Dynamic)
		{
		}
		#end
	}

	/**
	 * saveBytes is NOT supported for Assets.
	 */
	public static function saveBytes(path:String, bytes:Bytes):Void
	{
		trace("Warning: saveBytes is not supported for Assets!");
	}

	/**
	 * write is NOT supported for Assets.
	 */
	public static function write(path:String, binary:Bool = true):Dynamic
	{
		trace("Warning: File.write is not supported for Assets!");
		return null;
	}
}
#else
typedef FileSystem = sys.FileSystem;
typedef File = sys.io.File;
#end
