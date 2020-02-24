//
//  MimeType.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 27/11/19.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

enum MimeType: String {
    case html
    case htm
    case shtml
    case css
    case xml
    case gif
    case jpeg
    case jpg
    case js
    case atom
    case rss
    case mml
    case txt
    case jad
    case wml
    case htc
    case png
    case tif
    case tiff
    case wbmp
    case ico
    case jng
    case bmp
    case svg
    case svgz
    case webp
    case woff
    case jar
    case war
    case ear
    case json
    case hqx
    case doc
    case pdf
    case ps
    case eps
    case ai
    case rtf
    case m3u8
    case xls
    case eot
    case ppt
    case wmlc
    case kml
    case kmz
    case sevenZ = "7z"
    case cco
    case jardiff
    case jnlp
    case run
    case pl
    case pm
    case prc
    case pdb
    case rar
    case rpm
    case sea
    case swf
    case sit
    case tcl
    case tk
    case der
    case pem
    case crt
    case xpi
    case xhtml
    case xspf
    case zip
    case bin
    case exe
    case dll
    case deb
    case dmg
    case iso
    case img
    case msi
    case msp
    case msm
    case docx
    case xlsx
    case pptx
    case mid
    case midi
    case kar
    case mp3
    case ogg
    case m4a
    case ra
    case threeGpp = "3gpp"
    case threeGp = "3gp"
    case ts
    case mp4
    case mpeg
    case mpg
    case mov
    case webm
    case flv
    case m4v
    case mng
    case asx
    case asf
    case wmv
    case avi
    
    var value: String {
        switch self {
        case .html, .htm, .shtml:
            return "text/html"
        case .css:
            return "text/css"
        case .xml:
            return "text/xml"
        case .gif:
            return "image/gif"
        case .jpeg, .jpg:
            return "image/jpeg"
        case .js:
            return "application/javascript"
        case .atom:
            return "application/atom+xml"
        case .rss:
            return "application/rss+xml"
        case .mml:
            return "text/mathml"
        case .txt:
            return "text/plain"
        case .jad:
            return "text/vnd.sun.j2me.app-descriptor"
        case .wml:
            return "text/vnd.wap.wml"
        case .htc:
            return "text/x-component"
        case .png:
            return "image/png"
        case .tif, .tiff:
            return "image/tiff"
        case .wbmp:
            return "image/vnd.wap.wbmp"
        case .ico:
            return "image/x-icon"
        case .jng:
            return "image/x-jng"
        case .bmp:
            return "image/x-ms-bmp"
        case .svg, .svgz:
            return "image/svg+xml"
        case .webp:
            return "image/webp"
        case .woff:
            return "application/font-woff"
        case .jar, .war, .ear:
            return "application/java-archive"
        case .json:
            return "application/json"
        case .hqx:
            return "application/mac-binhex40"
        case .doc:
            return "application/msword"
        case .pdf:
            return "application/pdf"
        case .ps, .eps, .ai:
            return "application/postscript"
        case .rtf:
            return "application/rtf"
        case .m3u8:
            return "application/vnd.apple.mpegurl"
        case .xls:
            return "application/vnd.ms-excel"
        case .eot:
            return "application/vnd.ms-fontobject"
        case .ppt:
            return "application/vnd.ms-powerpoint"
        case .wmlc:
            return "application/vnd.wap.wmlc"
        case .kml:
            return "application/vnd.google-earth.kml+xml"
        case .kmz:
            return "application/vnd.google-earth.kmz"
        case .sevenZ:
            return "application/x-7z-compressed"
        case .cco:
            return "application/x-cocoa"
        case .jardiff:
            return "application/x-java-archive-diff"
        case .jnlp:
            return "application/x-java-jnlp-file"
        case .run:
            return "application/x-makeself"
        case .pl, .pm:
            return "application/x-perl"
        case .prc, .pdb:
            return "application/x-pilot"
        case .rar:
            return "application/x-rar-compressed"
        case .rpm:
            return "application/x-redhat-package-manager"
        case .sea:
            return "application/x-sea"
        case .swf:
            return "application/x-shockwave-flash"
        case .sit:
            return "application/x-stuffit"
        case .tcl, .tk:
            return "application/x-tcl"
        case .der, .pem, .crt:
            return "application/x-x509-ca-cert"
        case .xpi:
            return "application/x-xpinstall"
        case .xhtml:
            return "application/xhtml+xml"
        case .xspf:
            return "application/xspf+xml"
        case .zip:
            return "application/zip"
        case .bin, .exe, .dll, .deb, .dmg, .iso, .img, .msi, .msp, .msm:
            return "application/octet-stream"
        case .docx:
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case .xlsx:
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case .pptx:
            return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case .mid, .midi, .kar:
            return "audio/midi"
        case .mp3:
            return "audio/mpeg"
        case .ogg:
            return "audio/ogg"
        case .m4a:
            return "audio/x-m4a"
        case .ra:
            return "audio/x-realaudio"
        case .threeGpp, .threeGp:
            return "video/3gpp"
        case .ts:
            return "video/mp2t"
        case .mp4:
            return "video/mp4"
        case .mpeg, .mpg:
            return "video/mpeg"
        case .mov:
            return "video/quicktime"
        case .webm:
            return "video/webm"
        case .flv:
            return "video/x-flv"
        case .m4v:
            return "video/x-m4v"
        case .mng:
            return "video/x-mng"
        case .asx, .asf:
            return "video/x-ms-asf"
        case .wmv:
            return "video/x-ms-wmv"
        case .avi:
            return "video/x-msvideo"
        }
    }
    
    var generateFileName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let date = formatter.string(from: Date())
        return self.rawValue.uppercased() + "_" + date + "." + self.rawValue
    }
}
