import QtQuick 2.12
import org.kde.kirigami 2.12 as Kirigami

Kirigami.ApplicationWindow {
    id: root
    Kirigami.PageRouter {
        pageStack: root.pageStack.columnView

        Kirigami.PageRoute {
            name: "home"
            Component {
                Kirigami.Page {
                    // Page contents...
                }
            }
        }
        initialRoute: "home"
        Component.onCompleted: navigateToRoute("home", "home")
    }
}