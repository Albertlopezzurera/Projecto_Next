/// Clase User contiene los campos necesarios para iniciar sesion de un usuario.
///
/// [_token] -> String -> Para poder recoger datos de la API
class User {
  String _username;
  int _idusername;
  String _nombre;
  String _dominio;
  String _token;
  int _iddominio;

  User({
    String username = '',
    int idusername = 0,
    String nombre = '',
    String dominio = '',
    String token = '',
    int iddominio = 0,
  })  : _username = username,
        _idusername = idusername,
        _nombre = nombre,
        _dominio = dominio,
        _token = token,
        _iddominio = iddominio;

  String get username => _username;
  set username(String value) => _username = value;

  int get idusername => _idusername;
  set idusername(int value) => _idusername = value;

  String get nombre => _nombre;
  set nombre(String value) => _nombre = value;

  String get dominio => _dominio;
  set dominio(String value) => _dominio = value;

  String get token => _token;
  set token(String value) => _token = value;

  int get iddominio => _iddominio;
  set iddominio(int value) => _iddominio = value;



  @override
  String toString() {
    return 'User{_username: $_username, _idusername: $_idusername, _nombre: $_nombre, _dominio: $_dominio, _token: $_token, _iddominio: $_iddominio}';
  }
}