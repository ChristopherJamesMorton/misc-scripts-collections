while (-not ($proc.name -contains 'AmazonPhotos')) {
    start-process 'C:\Users\Christopher Morton\AppData\Local\Amazon Drive\AmazonPhotos.exe' -NoNewWindow -Wait
}