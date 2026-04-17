{
  lib,
  stdenv,
  pkgs,
  qt6,
  cmake,
  ninja,
  linkFarm,
  writeText,
}:

stdenv.mkDerivation rec {
  pname = "bigscreen-curtain";
  version = "0.1";

  src = linkFarm "bigscreen-curtain-src" [
    {
      name = "CMakeLists.txt";
      path = writeText "CMakeLists.txt" ''
        cmake_minimum_required(VERSION 3.16)
        project(bigscreen_curtain LANGUAGES CXX)

        set(CMAKE_CXX_STANDARD 17)
        set(CMAKE_CXX_STANDARD_REQUIRED ON)

        find_package(Qt6 REQUIRED COMPONENTS Widgets)
        qt_standard_project_setup()
        add_executable(bigscreen_curtain main.cpp)
        target_link_libraries(bigscreen_curtain PRIVATE Qt6::Widgets)
      '';
    }

    {
      name = "main.cpp";
      path = writeText "main.cpp" ''
                        #include <QApplication>
                        #include <QMainWindow>
                        #include <QTimer>

                        int main(int argc, char *argv[]) {
                            QApplication app(argc, argv);

                            QMainWindow window;

                            window.setWindowFlags(Qt::FramelessWindowHint);
                            window.setAttribute(Qt::WA_TranslucentBackground, true);
                            window.show();

        		    QTimer::singleShot(1000, [&]() {
                		window.show();
        			QTimer::singleShot(200, &app, &QCoreApplication::quit);
            		    });

                            return app.exec();
                	}
      '';
    }
  ];

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bigscreen_curtain $out/bin/
  '';

  meta = {
    description = "KDE Plasma Bigscreen Loading Curtain Workaround :P";
    platforms = lib.platforms.linux;
  };
}
