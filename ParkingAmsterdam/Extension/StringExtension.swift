import Foundation

extension String{
    func removeFirstCharacters() -> String{
        return String(self.characters.dropFirst(6))
    }
}
