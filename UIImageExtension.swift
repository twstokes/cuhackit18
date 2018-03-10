//
//  UIImageExtension.swift
//  secretPhoto
//
//  Created by Tanner W. Stokes on 3/9/18.
//  Copyright © 2018 Tanner W. Stokes. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    private struct PixelData {
        static let colorSpace = CGColorSpaceCreateDeviceRGB()
        static let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        static let bitsPerComponent = 8
        
        let pixels: UnsafeMutableBufferPointer<UInt32>
        let width: Int
        let height: Int
        let bytesPerRow: Int
    }
    
    private var pixelData: PixelData? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let height = cgImage.height
        let width = cgImage.width
        let bytesPerRow = 4 * width
        
        let rawData = UnsafeMutablePointer<UInt32>.allocate(capacity: (width * height))
        let CGPointZero = CGPoint(x: 0, y: 0)
        
        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: CGPointZero, size: size)
        
        guard let imageContext = CGContext(
            data: rawData,
            width: width,
            height: height,
            bitsPerComponent: PixelData.bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: PixelData.colorSpace,
            bitmapInfo: PixelData.bitmapInfo
            ) else {
                return nil
        }
        
        imageContext.draw(cgImage, in: rect)
        
        let unsafeBuffer = UnsafeMutableBufferPointer<UInt32>(start: rawData, count: width * height)
        
        return PixelData(
            pixels: unsafeBuffer,
            width: width,
            height: height,
            bytesPerRow: bytesPerRow
        )
    }
    
    func encodeSecret(secret: String) -> UIImage? {
        guard let pixelData = self.pixelData else {
            debugPrint("Couldn't get pixels!")
            return nil
        }
        
        guard var secretData = secret.data(using: .utf8), pixelData.pixels.count >= secretData.count * 8 else {
            debugPrint("Source too small for secret.")
            return nil
        }
        
        // hack - grow or shrink to lock to 32 bytes
        if secretData.count < 32 {
            let filler = 32 - secretData.count

            for _ in 1...filler {
                secretData.append(0)
            }
        } else {
            secretData = secretData.subdata(in: Range(0..<32))
        }
        
        var offset = 0
        
        for byte in secretData {
            for index in 0..<8 {
                let pop = (byte >> index) & 1
                // this doesn't evenly distribute across colors, just reds
                pixelData.pixels[index+offset] = (pixelData.pixels[index+offset] & 4294967294) + UInt32(pop)
            }
            offset += 8
        }
        
        guard let outContext = CGContext(
            data: pixelData.pixels.baseAddress,
            width: pixelData.width,
            height: pixelData.height,
            bitsPerComponent: PixelData.bitsPerComponent,
            bytesPerRow: pixelData.bytesPerRow,
            space: PixelData.colorSpace,
            bitmapInfo: PixelData.bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
            ) else {
                return nil
        }
        
        guard let outCGImage = outContext.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: outCGImage)
    }
    
    // this would be a great candidate for a callback
    // since the main thread hangs up
    func decodeSecret() -> String? {
        guard let pixelData = self.pixelData else {
            debugPrint("Couldn't get pixels!")
            return nil
        }
        
        var decodedData = Data()
        var newByte = UInt8()
        var newByteIndex = 0
        
        for pixel in pixelData.pixels {
            let lastBit = pixel & 1
            
            newByte = newByte + (UInt8(lastBit) << newByteIndex)
            newByteIndex += 1
            
            if newByteIndex == 8 {
                decodedData.append(newByte)
                newByte = 0
                newByteIndex = 0
            }
        }
        
        if let secret = String(data: decodedData.subdata(in: Range(0..<32)), encoding: .utf8) {
            debugPrint("Successfully created string.")
            return secret
        } else {
            debugPrint("Couldn't create a decoded string.")
            return nil
        }
    }
}

