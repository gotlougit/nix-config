{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libdecsync,
  vobject,
}:

buildPythonPackage rec {
  pname = "radicale-storage-decsync";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "39aldo39";
    repo = "Radicale-DecSync";
    rev = "v${version}";
    sha256 = "1ryqv8cfwpnji47kz2mv6fzfddy7hblspwfmviyvxarmzpgq0115";
  };

  patches = [
    ./handle-multiple-args-discovery.patch
  ];

  propagatedBuildInputs = [
    libdecsync
    vobject
  ];

  # No tests in the repository
  doCheck = false;

  # Skip import check due to libcrypt.so.1 dependency issue with libdecsync
  pythonImportsCheck = [ ];

  meta = with lib; {
    description = "DecSync storage plugin for Radicale";
    longDescription = ''
      Radicale DecSync is a Radicale storage plugin which adds synchronization
      of contacts and calendars using DecSync. This allows you to use DecSync
      on any CalDAV/CardDAV compatible client like Thunderbird. To start
      synchronizing, all you have to do is synchronize the DecSync directory
      (by default ~/.local/share/decsync), using for example Syncthing.
    '';
    homepage = "https://github.com/39aldo39/Radicale-DecSync";
    license = licenses.gpl3Plus;
    # maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
