import Foundation
import UIKit

class SimpleCache: NSObject, URLSessionTaskDelegate {
	
	class var sharedInstance: SimpleCache {
		struct Singleton {
			static let instance = SimpleCache()
		}
		return Singleton.instance
	}
	
	var session:URLSession!
	var URLCache = Foundation.URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
	var downloadQueue = Dictionary<URL, (UIImage?, NSError?)->()?>()
	
	override init() {
		super.init()
		
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
		config.urlCache = URLCache
		
		self.session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
	}
	
	func getImageFromCache(_ url:URL, completion:@escaping (UIImage?, NSError?)->()) {
		let urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0)
		if let response = URLCache.cachedResponse(for: urlRequest) {
			let image = UIImage(data: response.data)
			DispatchQueue.main.async { () -> Void in
				completion(image, nil)
				return
			}
		} else {
			completion(nil, nil)
		}
	}
	
	func getImage(_ url:URL, completion:((UIImage?, NSError?)->())?) {
		
		let urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0)

		if let response = URLCache.cachedResponse(for: urlRequest) {
			let image = UIImage(data: response.data)
			DispatchQueue.main.async { () -> Void in
				completion?(image, nil)
				return
			}
		} else {
			let task = self.session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) -> Void in
				if let strongSelf = self {
					if let completionHandler = strongSelf.downloadQueue[url] {
						if let errorReceived = error {
						print("ERROR >>>>>>>>> \(errorReceived.localizedDescription)")
							DispatchQueue.main.async { 
								completionHandler(nil, nil)
								return
							}
						} else {
							if let httpResponse = response as? HTTPURLResponse {
								if httpResponse.statusCode >= 400 {
									completionHandler(nil, NSError(domain: NSURLErrorDomain, code: httpResponse.statusCode, userInfo: nil))
								} else {
//									println(" >>>>>>>>> LENGTHS: \(response.expectedContentLength) - got: \(data.length)")
									strongSelf.URLCache.storeCachedResponse(CachedURLResponse(response:response!, data:data!, userInfo:nil, storagePolicy:Foundation.URLCache.StoragePolicy.allowed), for: urlRequest)
								
									let image = UIImage(data: data!)
									DispatchQueue.main.async { 
										completionHandler(image, nil)
										return
									}
								}
							}
						}
					}
					strongSelf.cancelImage(url)
				}
			}) 
			addToQueue(url, task, completion: completion)
		}
	}
	
	func cancelImage(_ requestUrl:URL?) {
		if let url = requestUrl {
			if let index = self.downloadQueue.index(forKey: url) {
				self.downloadQueue.remove(at: index)
			}
		}
	}
	
	
	// MARK: - Private
	
	fileprivate func addToQueue(_ url:URL, _ task:URLSessionDataTask, completion:((UIImage?, NSError?)->())?) {
		self.downloadQueue[url] = completion
		if task.state != .running {
			task.resume()
		}
	}
}
