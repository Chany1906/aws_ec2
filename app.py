from flask import Flask, request, render_template
import boto3

app = Flask(__name__)
s3_client = boto3.client('s3')

@app.route('/')
def index():
    # Listar reportes en S3
    response = s3_client.list_objects_v2(Bucket='output-bucket-name')
    reportes = [obj['Key'] for obj in response.get('Contents', [])]
    
    # Filtro por marca
    marca = request.args.get('marca')
    if marca:
        reportes = [r for r in reportes if marca in r]
    
    return render_template('index.html', reportes=reportes)

@app.route('/reporte/<key>')
def ver_reporte(key):
    obj = s3_client.get_object(Bucket='output-bucket-name', Key=key)
    contenido = obj['Body'].read().decode('utf-8')
    return contenido

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)