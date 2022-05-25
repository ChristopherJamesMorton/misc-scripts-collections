while (-not ($proc.name -contains 'AmazonPhotos')) {
    start-process 'C:\Users\Administrator\AppData\Local\Amazon Drive\AmazonPhotos.exe' -NoNewWindow -Wait
}
