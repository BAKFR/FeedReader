//	This file is part of FeedReader.
//
//	FeedReader is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	FeedReader is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with FeedReader.  If not, see <http://www.gnu.org/licenses/>.

public class FeedReader.grabberUtils : GLib.Object {

	public static int ParserOption = Html.ParserOption.NOERROR + Html.ParserOption.NOWARNING;

	public grabberUtils()
	{

	}

	public static bool extractBody(GXml.HtmlDocument doc, string xpath, GXml.HtmlDocument destination)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);

				if(node == null)
					return false;

				// remove property "style" of all tags
				node.remove_attribute("style");
				doc.remove_child(node);
				destination.append_child(node);
			}

			return res.nodeset.length > 0;
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.extractBody: " + e.message);
			return false;
		}
	}

	public static string? getURL(GXml.HtmlDocument doc, string xpath)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET
			|| res.nodeset.length == 0)
			{
				Logger.error(@"grabberUtils.getURL failed - xpath: $xpath");
				return null;
			}

			GXml.DomElement? node = res.nodeset.item(0);
			return node.get_attribute("href");
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.getURL: " + e.message);
			Logger.error(@"grabberUtils.getURL: xpath $xpath");
			return null;
		}
	}

	public static string? getValue(GXml.HtmlDocument doc, string xpath, bool remove = false)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET
			|| res.nodeset.length == 0)
			{
				Logger.error(@"grabberUtils.getValue failed - xpath: $xpath");
				return null;
			}

			GXml.DomElement node = res.nodeset.item(0);
			string val = cleanString(node.text_content);

			if(remove)
				doc.remove_child(node);

			return val;
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.getValue: " + e.message);
			Logger.error(@"grabberUtils.getValue: xpath $xpath");
			return null;
		}
	}

	public static bool repairURL(string xpath, string attr, GXml.HtmlDocument doc, string articleURL)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);
				if(node != null && node.has_attribute(attr))
					node.set_attribute(attr, completeURL(node.get_attribute(attr), articleURL));
			}

			return true;
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.repairURL: " + e.message);
			return false;
		}
	}

	public static bool fixLazyImg(GXml.HtmlDocument doc, string className, string correctURL)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(@"//img[contains(@class, '$className')]");
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);
				if(node != null)
					node.set_attribute("src", node.get_attribute(correctURL));
			}

			return true;
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.fixLazyImg: " + e.message);
			return false;
		}
	}

	public static bool fixIframeSize(GXml.HtmlDocument doc, string siteName)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(@"//iframe[contains(@src, '$siteName')]");
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);
				GXml.DomElement? parent = node.parent_element;
				GXml.DomElement? videoWrapper = doc.create_element("div") as GXml.DomElement;

				videoWrapper.set_attribute("class", "videoWrapper");
				node.set_attribute("width", "100%");
				node.remove_attribute("height");

				doc.remove_child(node);
				videoWrapper.append_child(node);
				parent.append_child(videoWrapper);
			}

			return true;
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.fixIframeSize: " + e.message);
			return false;
		}
	}

	public static void stripNode(GXml.HtmlDocument doc, string xpath)
	{
		try
		{
			string ancestor = xpath;
			if(ancestor.has_prefix("//"))
			{
				ancestor = ancestor.substring(2);
			}
			string query = @"$xpath[not(ancestor::$ancestor)]";

			GXml.XPathObject res = doc.evaluate(query);
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);

				if(node != null)
					doc.remove_child(node);
			}
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.stripNode: " + e.message);
		}
	}

	public static void onlyRemoveNode(GXml.HtmlDocument doc, string xpath)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);
				if(node == null)
					continue;

				GXml.DomNode? parent = node.parent_node;
				GXml.DomNodeList children = node.child_nodes;
				foreach(var n in children)
				{
					doc.remove_child(n);
					parent.append_child(n);
				}

				doc.remove_child(node);
			}
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.fixLazyImg: " + e.message);
		}
	}

	public static bool setAttributes(GXml.HtmlDocument doc, string attribute, string newValue)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(@"//*[@$attribute]");
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);

				if(node != null)
				{
					node.set_attribute(attribute, newValue);
					return true;
				}
			}
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.setAttributes: " + e.message);
		}

		return false;
	}

	public static bool removeAttributes(GXml.HtmlDocument doc, string? tag, string attribute)
	{
		try
		{
			string xpath = @"//*[@$attribute]";
			if(tag != null)
				xpath = @"//$tag[@$attribute]";

			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);

				if(node != null)
				{
					node.remove_attribute(attribute);
					return true;
				}
			}
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.removeAttributes: " + e.message);
		}

		return false;
	}

	public static bool addAttributes(GXml.HtmlDocument doc, string? tag, string attribute, string val)
	{
		try
		{
			string xpath = "//*";
			if(tag != null)
				xpath = @"//$tag";

			GXml.XPathObject res = doc.evaluate(xpath);
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);

				if(node != null)
				{
					node.set_attribute(attribute, val);
					return true;
				}
			}
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.removeAttributes: " + e.message);
		}

		return false;
	}

	public static void stripIDorClass(GXml.HtmlDocument doc, string IDorClass)
	{
		try
		{
			GXml.XPathObject res = doc.evaluate(@"//*[contains(@class, '$IDorClass') or contains(@id, '$IDorClass')]");
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				GXml.DomElement? node = res.nodeset.item(i);
				if(node == null)
					continue;

				if(node.has_attribute("class")
				|| node.has_attribute("id")
				|| node.has_attribute("src"))
					doc.remove_child(node);
			}
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.stripIDorClass: " + e.message);
		}
	}

	public static string cleanString(string? text)
	{
		if(text == null)
			return "";

		var tmpText =  text.replace("\n", "");
		var array = tmpText.split(" ");
		tmpText = "";

		foreach(string word in array)
		{
			if(word.chug() != "")
			{
				tmpText += word + " ";
			}
		}

		return tmpText.chomp();
	}

	public static string completeURL(string incompleteURL, string articleURL)
	{
		int index = 0;
		if(articleURL.has_prefix("http"))
		{
			index = 8;
		}
		else
			index = articleURL.index_of_char('.', 0);

		string baseURL = "";

		if(incompleteURL.has_prefix("/") && !incompleteURL.has_prefix("//"))
		{
			index = articleURL.index_of_char('/', index);
			baseURL = articleURL.substring(0, index);
			if(baseURL.has_suffix("/"))
			{
				baseURL = baseURL.substring(0, baseURL.char_count()-1);
			}
			return baseURL + incompleteURL;
		}
		else if(incompleteURL.has_prefix("?"))
		{
			index = articleURL.index_of_char('?', index);
			baseURL = articleURL.substring(0, index);
			return baseURL + incompleteURL;
		}
		else if(!incompleteURL.has_prefix("http")
		&& !incompleteURL.has_prefix("www")
		&& !incompleteURL.has_prefix("//"))
		{
			index = articleURL.index_of_char('/', index);
			baseURL = articleURL.substring(0, index);
			if(!baseURL.has_suffix("/"))
			{
				baseURL = baseURL + "/";
			}
			return baseURL + incompleteURL;
		}
		else if(incompleteURL.has_prefix("//"))
		{
			return "http:" + incompleteURL;
		}

		return incompleteURL;
	}

	public static string buildHostName(string URL, bool cutSubdomain = true)
	{
		string hostname = URL;
		if(hostname.has_prefix("http://"))
		{
			hostname = hostname.substring(7);
		}
		else if(hostname.has_prefix("https://"))
		{
			hostname = hostname.substring(8);
		}

		if(hostname.has_prefix("www."))
		{
			hostname = hostname.substring(4);
		}

		int index = hostname.index_of_char('/');
		hostname = hostname.substring(0, index);

		if(cutSubdomain)
		{
			index = hostname.index_of_char('.');
			if(index != -1 && hostname.index_of_char('.', index+1) != -1)
			{
				hostname = hostname.substring(index);
			}
		}

		return hostname;
	}


	public static bool saveImages(Soup.Session session, GXml.HtmlDocument doc, string articleID, string feedID, GLib.Cancellable? cancellable = null)
	{
		try
		{
			Logger.debug(@"GrabberUtils: save Images: $articleID, $feedID");
			GXml.XPathObject res = doc.evaluate("//img");
			if(res.object_type != GXml.XPathObjectType.NODESET)
				return false;

			for(int i = 0; i < res.nodeset.length; i++)
			{
				if(cancellable != null && cancellable.is_cancelled())
					break;

				GXml.DomElement? node = res.nodeset.item(i);
				if(node == null)
					continue;

				if(node.has_attribute("src"))
				{
					if(
						((node.has_attribute("width") && int.parse(node.get_attribute("width")) > 1)
						|| !node.has_attribute("width"))
					&&
						((node.has_attribute("height") && int.parse(node.get_attribute("height")) > 1)
						|| !node.has_attribute("height"))
					)
					{
						string? original = downloadImage(session, node.get_attribute("src"), articleID, feedID, i+1);

						if(original == null)
							continue;

						string? parentURL = checkParent(session, node);
						if(parentURL != null)
						{
							string parent = downloadImage(session, parentURL, articleID, feedID, i+1, true);

							if(compareImageSize(parent, original) > 0)
							{
								// parent is bigger than orignal image
								node.set_attribute("src", original);
								node.set_attribute("FR_parent", parent);
							}
							else
							{
								// parent is no improvement over orignal image
								// just delete parent again and only set orignal
								GLib.FileUtils.remove(parent);
								node.set_attribute("src", original);
							}
						}
						else
						{
							string? resized = resizeImg(original);
							if(resized != null)
							{
								node.set_attribute("src", resized);
								node.set_attribute("FR_huge", original);
							}
							else
								node.set_attribute("src", original);
						}
					}
				}
			}
			return true;
		}
		catch(Error e)
		{
			Logger.error("grabberUtils.saveImages: " + e.message);
		}

		return false;
	}


	public static string? downloadImage(Soup.Session session, string? url, string articleID, string feedID, int nr, bool parent = false)
	{
		if(url == null)
			return null;

		string fixedURL = url;
		string imgPath = "";

		if(fixedURL.has_prefix("//"))
		{
			fixedURL = "http:" + fixedURL;
		}

		if(articleID == "" && feedID == "")
			imgPath = GLib.Environment.get_user_data_dir() + "/debug-article/ArticleImages/";
		else
			imgPath = GLib.Environment.get_user_data_dir() + "/feedreader/data/images/%s/%s/".printf(feedID.replace("/", "_"), articleID);

		var path = GLib.File.new_for_path(imgPath);
		try
		{
			path.make_directory_with_parents();
		}
		catch(GLib.Error e)
		{
			//Logger.debug(e.message);
		}

		string localFilename = imgPath + nr.to_string();

		if(parent)
			localFilename += "_parent";

		if(!FileUtils.test(localFilename, GLib.FileTest.EXISTS))
		{
			var message_dlImg = new Soup.Message("GET", fixedURL);

			if(message_dlImg == null)
			{
				Logger.warning(@"grabberUtils.downloadImage: could not create soup message $fixedURL");
				return url;
			}

			if(Settings.tweaks().get_boolean("do-not-track"))
				message_dlImg.request_headers.append("DNT", "1");

			var status = session.send_message(message_dlImg);
			if(status == 200)
			{
				var params = new GLib.HashTable<string, string>(null, null);
				string? contentType = message_dlImg.response_headers.get_content_type(out params);
				if(contentType != null)
				{
					Logger.debug(@"Grabber: type $contentType");
					if(contentType.has_prefix("image/svg"))
					{
						localFilename += ".svg";
					}
				}

				try{
					FileUtils.set_contents(	localFilename,
											(string)message_dlImg.response_body.flatten().data,
											(long)message_dlImg.response_body.length);
				}
				catch(GLib.FileError e)
				{
					Logger.error("Error writing image: %s".printf(e.message));
					return url;
				}
			}
			else
			{
				Logger.error("Error downloading image: %s".printf(fixedURL));
				return url;
			}
		}

		return localFilename.replace("?", "%3F");
	}


	// if image is >2000px then resize it to 1000px and add FR_huge attribute
	// with url to original image
	private static string? resizeImg(string path)
	{
		try
		{
			int? height = 0;
			int? width = 0;
			Gdk.PixbufFormat? format = Gdk.Pixbuf.get_file_info(path, out width, out height);

			if(format == null || height == null || width == null)
				return null;

			if(width > 2000 || height > 2000)
			{
				int nHeight = 1000;
				int nWidth = 1000;
				if(width > height)
					nHeight = -1;
				else if(height > width)
					nWidth = -1;

				var img = new Gdk.Pixbuf.from_file_at_scale(path, nWidth, nHeight, true);
				img.save(path + "_resized", "png");
				return path + "_resized";
			}
		}
		catch(GLib.Error e)
		{
			Logger.error("Error resizing image: %s".printf(e.message));
			return null;
		}
		return null;
	}

	// receives 2 paths to images stored on the hdd and compares the size
	// 1: file1 > file2
	// 0: file1 = file2
	// -1: file1 < file2
	private static int compareImageSize(string file1, string file2)
	{
		int? height1 = 0;
		int? width1 = 0;
		Gdk.Pixbuf.get_file_info(file1, out width1, out height1);

		int? height2 = 0;
		int? width2 = 0;
		Gdk.Pixbuf.get_file_info(file2, out width2, out height2);

		if(height1 == null
		|| width1 == null
		|| height2 == null
		|| width2 == null)
		{
			Logger.warning("Utils.compareImageSize: couldn't read image sizes");
			return 0;
		}

		if(height1 == height2
		&& width1 == width2)
			return 0;
		else if(height1*width1 > height2*width2)
			return 1;
		else
			return -1;
	}

	// check if the parent node is a link that points to a picture
	// (most likely a bigger version of said picture)
	private static string? checkParent(Soup.Session session, GXml.DomElement node)
	{
		Logger.debug("Grabber: checkParent");
		string smallImgURL = node.get_attribute("src");
		int64 origSize = 0;
		int64 size = 0;
		GXml.DomElement parent = node.parent_element;
		string name = parent.tag_name;
		Logger.debug(@"Grabber: parent $name");
		if(name == "a")
		{
			string url = parent.get_attribute("href");

			if(url != "" && url != null)
			{
				if(url.has_prefix("//"))
					url = "http:" + url;

				var message = new Soup.Message("HEAD", url);
				if(message == null)
					return null;
				session.send_message(message);
				var params = new GLib.HashTable<string, string>(null, null);
				string? contentType = message.response_headers.get_content_type(out params);
				size = message.response_headers.get_content_length();
				var message2 = new Soup.Message("HEAD", smallImgURL);
				if(message2 == null)
					return null;
				session.send_message(message2);
				origSize = message2.response_headers.get_content_length();
				if(contentType != null)
				{
					Logger.debug(@"Grabber: type $contentType");
					if(contentType.has_prefix("image/"))
					{
						if(size != 0 && origSize != 0)
						{
							if(size > origSize)
								return url;
							else
								return null;
						}
						else
							return url;
					}
				}
			}
		}

		return null;
	}

	public static string postProcessing(string html)
	{
		Logger.debug("GrabberUtils: postProcessing");
		string result = html.replace("<h3/>", "<h3></h3>");

		int pos1 = result.index_of("<iframe", 0);
		int pos2 = -1;
		while(pos1 != -1)
		{
			pos2 = result.index_of("/>", pos1);
			string broken_iframe = result.substring(pos1, pos2+2-pos1);
			Logger.debug("GrabberUtils: broken = %s".printf(broken_iframe));
			string fixed_iframe = broken_iframe.substring(0, broken_iframe.length-2) + "></iframe>";
			Logger.debug("GrabberUtils: fixed = %s".printf(fixed_iframe));
			result = result.replace(broken_iframe, fixed_iframe);
			int pos3 = result.index_of("<iframe", pos1+7);
			if(pos3 == pos1 || pos3 > result.length)
				break;
			else
				pos1 = pos3;
		}
		Logger.debug("GrabberUtils: postProcessing done");
		return result;
	}
}
