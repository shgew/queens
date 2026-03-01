# Repository Notes

- Package/Xcode linking policy: when creating, moving, or editing local Swift packages (`Dependencies/*`), do not modify `Queens.xcodeproj` package references or package product linking automatically. Instruct the user to perform Xcode package linking manually.
- Swift organization policy: place helper methods and helper computed properties in extensions, and keep helper access control on the members themselves (use `extension` with `private` members, not `private extension`).
